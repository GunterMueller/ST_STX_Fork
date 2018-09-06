"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPCScanner
	instanceVariableNames:'match matchPosition matches tokens currentChar maxSymbolNumber
		position context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!


!PPCScanner class methodsFor:'as yet unclassified'!

acceptsLoggingOfCompilation
"	^ self == PPCScanner"
    ^ true
! !

!PPCScanner methodsFor:'accessing'!

maxSymbolNumber
    ^ maxSymbolNumber
!

maxSymbolNumber: value
    maxSymbolNumber := value
!

position
    "returns the start position before the scan method..."
    ^ position
!

stream
    ^ context
!

stream: anObject
    context := anObject
! !

!PPCScanner methodsFor:'initialization'!

initialize
    super initialize.
    
    maxSymbolNumber := self class classVarNamed: #MaxSymbolNumber.
    tokens := self class classVarNamed: #Tokens.
    
    matches := Array new: maxSymbolNumber withAll: -2.
    position := 0.
!

reset
    matchPosition := nil. "This flag says that multimode run the last time"

    position := context position.
"	matches := Array new: maxSymbolNumber."
!

reset: tokenList
    "Method should not be used, it is here for debugging and testing purposes"
    self error: 'deprecated'.
    
    matchPosition := nil. "This flag says that multimode run the last time"
    
    tokens := tokenList.
    matches := Array new: tokens size.
    
!

resetDistinct
"	matches := IdentityDictionary new.	"
    match := nil.
    matchPosition := -1.						"this is a flag that the distnict mode was running"
"	matches := nil."

    position := context position.
    
! !

!PPCScanner methodsFor:'results'!

backtrack
    matchPosition := nil.
    match := nil.
    matches := Array new: maxSymbolNumber withAll: -2.
    position := 0.
!

backtrackDistinct
    matchPosition := nil.
    match := nil.
    position := 0.
!

backtracked
    ^ position == 0
!

indexOf: symbol
    (1 to: tokens size) do: [ :index | (tokens at: index) == symbol ifTrue: [^ index ] ]. 
!

match
"	^ match isNil not."
    ^ match isNotNil
"	^ matchPosition isNil not"
!

match: symbolNumber
"	matches isNil ifTrue: [ ^ false ]."
    
    "
        The general idea here is optimization. I cannot initialize 
        the matches before each token, it would be too expensive.
    "
    ^ (matches at: symbolNumber) > position
!

matchSymbol: symbol
    matches isNil ifTrue: [ ^ false ].
    (1 to: tokens size) do: [ :index | (tokens at: index) == symbol ifTrue: [
        ^ (matches at: index) > position
    ] ]. 
!

polyResult
    | dictionary |
    "TODO JK: refactor"	
    self isSingleMatch ifFalse: [ 
        dictionary := IdentityDictionary new.
        (1 to: matches size) do: [ :index | 
            (self match: index) ifTrue: [ 
                dictionary 
                    at: (tokens at: index)
                    put: (matches at: index)
            ]
        ].
        ^ dictionary
    ].

    dictionary := IdentityDictionary new.
    match isNil ifFalse: [ 
        dictionary at: match put: matchPosition.
    ].

    ^ dictionary
!

result
    ^ match
!

resultPosition
    ^ matchPosition
!

resultPosition: symbolNumber
    ^ matches at: symbolNumber
!

resultPositionForSymbol: symbol
    tokens isNil ifTrue: [ ^ false ].
    (1 to: tokens size) do: [ :index | (tokens at: index) == symbol ifTrue: [
        ^ matches at: index
    ] ]. 
! !

!PPCScanner methodsFor:'results - distinct'!

recordDistinctFailure
    match := nil.
    matchPosition := position.
    ^ false
!

recordDistinctFailure: matchValue
    match := matchValue.
    matchPosition := context position.
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

returnDistinct
    ^ match isNotNil
! !

!PPCScanner methodsFor:'results - universal'!

recordFailure: index
    matches at: index put: -1.
!

recordFailure: index offset: offset
    matches at: index put: -1.
!

recordMatch: index
 	matches at: index put: context position.
!

recordMatch: index offset: offset
    currentChar isNil ifFalse: [ 
        matches at: index put: context position - offset.
    ] ifTrue: [ 
        matches at: index put: context position.
    ].
 
!

return
    ^ matches
! !

!PPCScanner methodsFor:'scanning'!

back
    currentChar isNil ifFalse: [ 
        context skip: -1
    ]
!

peek
    self flag: 'inline this, do not call peek!!'.
    ^ currentChar
!

peekBetween: start and: stop
    (currentChar == nil) ifTrue: [ ^ false ].
    ^ (start <= currentChar codePoint) and: [ currentChar codePoint <= stop ]
!

step
    currentChar := context next
! !

!PPCScanner methodsFor:'testing'!

isSingleMatch
    ^ (matchPosition == nil) not
! !

!PPCScanner class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

