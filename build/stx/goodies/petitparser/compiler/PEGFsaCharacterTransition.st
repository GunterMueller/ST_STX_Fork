"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PEGFsaTransition subclass:#PEGFsaCharacterTransition
	instanceVariableNames:'characterSet'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaCharacterTransition methodsFor:'accessing'!

acceptsCodePoint: codePoint
    self assert: codePoint isInteger.
    (codePoint < 1) ifTrue: [ ^ false ].
    ^ characterSet at: codePoint
!

beginOfRange
    characterSet withIndexDo: [ :e :index | 
        e ifTrue: [ ^ index ]
    ].
    self error: 'should not happend'
!

character
 	self assert: (self isSingleCharacter).
	characterSet withIndexDo: [ :e :index | e ifTrue: [ ^ Character codePoint: index ] ].
	self error: 'should not happen'.
!

characterSet
    ^ characterSet
!

characterSet: anObject
    characterSet := anObject
!

endOfRange
    | change |
    change := false.
    characterSet withIndexDo: [ :e :index | 
        e ifTrue: [ change := true ].
        (e not and: [ change ]) ifTrue: [ ^ index - 1]
    ].
    ^ characterSet size
!

notCharacter
    self assert: self isNotSingleCharacter.
    characterSet withIndexDo: [ :value :index | value ifFalse: [ ^ Character codePoint: index ] ].
    ^ self error: 'should not happen'
! !

!PEGFsaCharacterTransition methodsFor:'comparing'!

= anotherTransition
    "
    Please note the identity comparison on destination
    If you use equality instead of identy, you will get infinite loop.

    So much for comparison by now :)	
    "
    super = anotherTransition ifFalse: [ ^ false ].
    (characterSet = anotherTransition characterSet) ifFalse: [ ^ false ].
    
    ^ true
!

canBeIsomorphicTo: anotherTransition
    (super canBeIsomorphicTo: anotherTransition) ifFalse: [ ^ false ].
    (characterSet = anotherTransition characterSet) ifFalse: [ ^ false ].
    
    ^ true
!

equals: anotherTransition
    (super equals: anotherTransition) ifFalse: [ ^ false ].
    (characterSet = anotherTransition characterSet) ifFalse: [ ^ false ].

    "JK: If character set and destination are the same, priority does not really matter"
    ^ true
!

hash
    ^ super hash bitXor: characterSet hash
! !

!PEGFsaCharacterTransition methodsFor:'copying'!

postCopy
    super postCopy.
    characterSet := characterSet copy.
! !

!PEGFsaCharacterTransition methodsFor:'gt'!

gtName
    | gtName |
    gtName := self characterSetAsString.
    priority < 0 ifTrue: [ gtName := gtName, ',', priority asString ].
    ^ gtName
! !

!PEGFsaCharacterTransition methodsFor:'initialization'!

initialize
    super initialize.
    
    characterSet := Array new: 255 withAll: false.
! !

!PEGFsaCharacterTransition methodsFor:'modifications'!

addCharacter: character
    characterSet at: character codePoint put: true
! !

!PEGFsaCharacterTransition methodsFor:'printing'!

characterSetAsString
    | stream |
    stream := WriteStream on: ''.
    self printCharacterSetOn: stream.
    ^ stream contents
!

printCharacterSetOn: stream
    (self isLetter) ifTrue: [ 
        stream nextPutAll: '#letter'.
        ^ self
    ].

    (self isWord) ifTrue: [ 
        stream nextPutAll: '#word'.
        ^ self
    ].


    stream nextPut: $[.
    32 to: 126 do: [ :index |
        (characterSet at: index) ifTrue: [ 
            ((Character codePoint: index) == $") ifTrue: [ 
                stream nextPutAll: '""'.
            ] ifFalse: [ 
                stream nextPut: (Character codePoint: index)
            ]
        ]
    ].
    stream nextPut: $].
!

printOn: stream
    self printCharacterSetOn: stream.
    stream nextPutAll: ' ('.
    priority printOn: stream.
    stream nextPutAll: ')'.		
    stream nextPutAll: '-->'.
    destination printOn: stream.
    stream nextPutAll: '(ID: '.
    stream nextPutAll: self identityHash asString.
    stream nextPutAll: ')'.
! !

!PEGFsaCharacterTransition methodsFor:'set operations'!

complement: transition
    | complement |
    complement := Array new: 255.
    
    1 to: 255 do: [ :index |
        complement
            at: index 
            put: ((self characterSet at: index) and: [(transition characterSet at: index) not])
    ].

    ^ complement
!

intersection: transition
    | intersection |
    intersection := Array new: 255.
    
    transition isPredicateTransition ifTrue: [ ^ intersection  ].
    transition isEpsilonTransition ifTrue: [ self error: 'Dont know!!' ].
    
    1 to: 255 do: [ :index |
        intersection
            at: index 
            put: ((self characterSet at: index) and: [transition characterSet at: index])
    ].

    ^ intersection
!

union: transition
    | union |
    union := Array new: 255.
    
    1 to: 255 do: [ :index |
        union
            at: index 
            put: ((self characterSet at: index) or: [transition characterSet at: index])
    ].

    ^ union
! !

!PEGFsaCharacterTransition methodsFor:'testing'!

accepts: character
    self assert: character isCharacter.
    ^ self acceptsCodePoint: character codePoint
!

isAny
    ^ characterSet allSatisfy: [ :e | e ]
!

isCharacterTransition
    ^ true
!

isDigit
    characterSet withIndexDo: [ :value :index | 
        (Character codePoint: index) isDigit == value ifFalse: [ ^ false ]
    ].
    ^ true
!

isEmpty
    ^ characterSet allSatisfy: [ :e | e not ]
!

isEpsilon
    ^ false
!

isLetter
    characterSet withIndexDo: [ :value :index | 
        (Character codePoint: index) isLetter == value ifFalse: [ ^ false ]
    ].
    ^ true
!

isNotSingleCharacter
    ^ (characterSet select: [ :e | e not ]) size == 1
!

isSingleCharacter
    ^ (characterSet select: [ :e | e ]) size == 1
!

isSingleRange
    | changes previous |
    changes := 0.
    previous := false.
    characterSet do: [ :e | 
        (e == previous) ifFalse: [ changes := changes + 1 ].
        previous := e.
    ].
    ^ changes < 3
!

isWord
    characterSet withIndexDo: [ :value :index | 
        (Character codePoint: index) isAlphaNumeric == value ifFalse: [ ^ false ]
    ].
    ^ true
!

overlapsWith: transition
    transition isCharacterTransition ifFalse: [ ^ false ].
    self isEpsilon ifTrue: [ ^ true ].
    transition isEpsilon ifTrue: [ ^ true ].
    
    ^ (self intersection: transition) anySatisfy: [ :bool | bool ]
! !

!PEGFsaCharacterTransition methodsFor:'transformation'!

join: transition
    ^ self join: transition joinDictionary: Dictionary new.
!

join: transition joinDictionary: dictionary
    | newDestination newTransition |
"	pair := PEGFsaPair with: self with: transition.
    (dictionary includesKey: pair) ifTrue: [ ^ dictionary at: pair ].
    dictionary at: pair put: nil.
"	
    newDestination := self destination join: transition destination joinDictionary: dictionary.
    newDestination isNil ifTrue: [ self error: 'What a cycle!! I wonder, how does this happened!!' ].
    
    newTransition := PEGFsaCharacterTransition new.
    newTransition destination: newDestination.
    newTransition characterSet: (self intersection: transition).
    newTransition priority: (self priority min: transition priority).
    
"	^ dictionary at: pair put: newTransition"
    ^ newTransition 
!

mergeWith: transition
    | union |
    self assert: destination = transition destination.
    
    union := self union: transition.
    self characterSet: union
! !

