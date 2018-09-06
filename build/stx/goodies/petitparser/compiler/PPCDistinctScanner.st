"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCDistinctScanner
	instanceVariableNames:'position match matchPosition currentChar context returnBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!PPCDistinctScanner class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCDistinctScanner methodsFor:'accessing-private'!

getMatch
    ^ match
!

position
    "returns the start position before the scan method..."
    ^ position
!

position: anObject
    position := matchPosition := anObject
!

setMatch: value
    match := value
!

stream
    ^ context
!

stream: anObject
    context := anObject
! !

!PPCDistinctScanner methodsFor:'initialization'!

initialize
    super initialize.
    match := nil.
    position := 0.
    matchPosition := 0.
!

resetDistinct
! !

!PPCDistinctScanner methodsFor:'memoization'!

remember
    ^ position
!

restore: restorePosition
    context position: (matchPosition := position := restorePosition).
    match := nil
! !

!PPCDistinctScanner methodsFor:'results'!

polyResult
    | dictionary |
    dictionary := IdentityDictionary new.
    match isNil ifFalse: [ 
        dictionary at: match put: matchPosition.
    ].

    ^ dictionary
!

recordDistinctFailure
    self flag: 'Potential bug? What if there is something after the failure? Might that happen for distinct parser?'.
    
    match := nil.
    matchPosition := position.
    context position: position.
    ^ false
!

recordDistinctMatch: matchValue
    match := matchValue.
    matchPosition := context position.
    ^ true
!

recordDistinctMatch: matchValue offset: offset
    match := matchValue.
    
    currentChar isNil ifFalse: [ 
        matchPosition := context position - offset.
    ] ifTrue: [ 
        matchPosition := context position.
    ].
    ^ true
!

result
    ^ match
!

resultPosition
    ^ matchPosition
!

returnDistinct
"
    match isNil ifTrue: [ 
        self assert: matchPosition == position
    ].
"

    context position: matchPosition.
    ^ match isNotNil
! !

!PPCDistinctScanner methodsFor:'scanning'!

back
    currentChar isNil ifFalse: [ 
        context skip: -1
    ]
!

peekBetween: start and: stop
    (currentChar == nil) ifTrue: [ ^ false ].
    ^ (start <= currentChar codePoint) and: [ currentChar codePoint <= stop ]
!

step
    currentChar := context next
! !

