"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCCharacterNode
	instanceVariableNames:'character'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCCharacterNode methodsFor:'accessing'!

character
    ^ character
!

character: char
    character := char
!

defaultName
    ^ #char
! !

!PPCCharacterNode methodsFor:'analysis'!

acceptsEpsilon
    ^ false
!

firstCharSet
    ^ PPCharSetPredicate on: [:e | e = character ]
!

recognizedSentencesPrim
    ^ Array with: character asString
! !

!PPCCharacterNode methodsFor:'comparison'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ character = anotherNode character.
!

hash
    ^ super hash bitXor: character hash
! !

!PPCCharacterNode methodsFor:'printing'!

printNameOn: aStream
    super printNameOn: aStream.

    character = $" ifTrue: [ 
        "this is hack to allow for printing '' in comments..."
        aStream nextPutAll: ', '; nextPutAll: '$'''''.
        ^ self
    ].

    aStream nextPutAll: ', '; print: character.
! !

!PPCCharacterNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitCharacterNode: self
! !

