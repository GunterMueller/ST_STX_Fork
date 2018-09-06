"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PEGFsaTransition
	instanceVariableNames:'destination priority'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-FSA'
!

!PEGFsaTransition class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PEGFsaTransition methodsFor:'accessing'!

destination
    ^ destination
!

destination: anObject
    destination := anObject
!

priority
    ^ priority
!

priority: anObject
    priority := anObject
! !

!PEGFsaTransition methodsFor:'comparing'!

= anotherTransition
    "
    Please note the identity comparison on destination
    If you use equality instead of identy, you will get infinite loop.

    So much for comparison by now :)	
    "
    (self == anotherTransition) ifTrue: [ ^ true ].
    (self class == anotherTransition class) ifFalse: [ ^ false ].

    (destination == anotherTransition destination) ifFalse: [ ^ false ].
    (priority == anotherTransition priority) ifFalse: [ ^ false ].
    
    ^ true
!

canBeIsomorphicTo: anotherTransition
    (self class == anotherTransition class) ifFalse: [ ^ false ].
    (priority == anotherTransition priority) ifFalse: [ ^ false ].
    
    ^ true
!

equals: anotherTransition
    "this method is used for minimization of the FSA"
    
    (self == anotherTransition) ifTrue: [ ^ true ].
    (self class == anotherTransition class) ifFalse: [ ^ false ].

    (destination == anotherTransition destination) ifFalse: [ ^ false ].

    "JK: If character set and destination are the same, priority does not really matter"
    ^ true
!

hash
    ^ destination hash bitXor: priority hash
! !

!PEGFsaTransition methodsFor:'copying'!

postCopy
    super postCopy.
! !

!PEGFsaTransition methodsFor:'gt'!

gtName
    | gtName |
    gtName := self characterSetAsString.
    priority < 0 ifTrue: [ gtName := gtName, ',', priority asString ].
    ^ gtName
! !

!PEGFsaTransition methodsFor:'initialization'!

initialize
    super initialize.
    priority := 0.
! !

!PEGFsaTransition methodsFor:'modifications'!

decreasePriority
    self decreasePriorityBy: 1
!

decreasePriorityBy: value
    priority := priority - value
! !

!PEGFsaTransition methodsFor:'set operations'!

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

disjunction: transition
    | disjunction |
    disjunction := Array new: 255.
    
    1 to: 255 do: [ :index |
        disjunction
            at: index 
            put: ((self characterSet at: index) xor: (transition characterSet at: index))
    ].

    ^ disjunction

    "Modified: / 18-08-2015 / 22:41:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

intersection: transition
    | intersection |
    intersection := Array new: 255.
    
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

!PEGFsaTransition methodsFor:'testing'!

accepts: character
    ^ self subclassResponsibility
!

isCharacterTransition
    ^ false
!

isEpsilon
    ^ self isEpsilonTransition
!

isEpsilonTransition
    ^ false
!

isPredicateTransition
    ^ false
!

overlapsWith: transition
    ^ (self intersection: transition) anySatisfy: [ :bool | bool ]
! !

!PEGFsaTransition methodsFor:'transformation'!

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
    
    newTransition := PEGFsaTransition new.
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

