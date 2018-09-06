"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCCharacterNode subclass:#PPCNotCharacterNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCNotCharacterNode methodsFor:'accessing'!

defaultName
    ^ #notChar
! !

!PPCNotCharacterNode methodsFor:'as yet unclassified'!

accept: visitor
    ^ visitor visitNotCharacterNode: self
!

firstCharSet
    ^ PPCharSetPredicate on: [:e | (e = character) not ]
!

recognizedSentencesPrim
    | retval |

    retval := OrderedCollection new.
    "TODO JK: Works only for ASCII :("
    1 to: 255 do: [ :i |
        (character = (Character codePoint: i)) ifFalse: [ 
            retval add: (Character codePoint: i) asString 
        ]
    ].
    ^ retval
! !

!PPCNotCharacterNode methodsFor:'printing'!

printNameOn: aStream
    super printNameOn: aStream.

    character = $" ifTrue: [ 
        "this is hack to allow for printing '' in comments..."
        aStream nextPutAll: ', '; nextPutAll: '$'''''.
        ^ self
    ].

    aStream nextPutAll: ', not('; print: character; nextPutAll: ')'
! !

