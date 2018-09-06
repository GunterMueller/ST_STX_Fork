"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCCodeGen subclass:#PPCFSACodeGen
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!PPCFSACodeGen methodsFor:'accessing'!

methodCategory
    ^ 'generated - scanning'
! !

!PPCFSACodeGen methodsFor:'coding'!

codeAbsoluteReturn: code
    self code: '^ ', code
!

codeAssertPeek: t
    |   id  |
    self assert: (t isKindOf: PEGFsaTransition).

    (t isPredicateTransition and: [t isEOF]) ifTrue: [ 
        self codeOnLine: 'currentChar isNil'.
        ^ self
    ].

    (t isPredicateTransition) ifTrue: [ 
        self codeOnLine: t predicate asString, ' value: currentChar codePoint'.
        ^ self
    ].

    (t isAny) ifTrue: [ 
        self codeOnLine: 'true'.
        ^ self
    ].

    
    (t isSingleCharacter) ifTrue: [ 
        self codeOnLine: 'currentChar == ', t character storeString.
        ^ self
    ].

    (t isNotSingleCharacter) ifTrue: [ 
        self codeOnLine: 'currentChar ~~ ', t notCharacter storeString.
        ^ self
    ].

    (t isLetter) ifTrue: [ 
        self codeOnLine: 'currentChar isLetter'.
        ^ self
    ].

    (t isWord) ifTrue: [ 
        self codeOnLine: 'currentChar isAlphaNumeric'.
        ^ self
    ].

    (t isDigit) ifTrue: [ 
        self codeOnLine: 'currentChar isDigit'.
        ^ self
    ].

    (t isSingleRange) ifTrue: [ 
        | begin end |
        begin := t beginOfRange.
        end := t endOfRange.
        self codeOnLine: 'self peekBetween: ', begin asString, ' and: ', end asString.
        ^ self
    ].

    
    id := self idGen cachedSuchThat: [ :e | e = t characterSet ] 
                    ifNone: [ self idFor: t characterSet defaultName: 'characterSet' ].
    
    self addConstant: t characterSet as: id.
    self codeOnLine: '(currentChar isNotNil) and: [',  id, ' at: currentChar codePoint ]'.
!

codeAssertPeek: transition ifFalse: falseBlock
    self add: '('.
    self codeAssertPeek: transition.
    self addOnLine: ') ifFalse: [ '.
    falseBlock value.
    self addOnLine: ']'.
    self codeDot.
!

codeAssertPeek: t ifTrue: block
    self codeOnLine: '('.
    self codeAssertPeek: t.
    self codeOnLine: ') ifTrue: ['.
    self indent.
    self code: block.
    self dedent.
    self code: ']'.
!

codeAssertPeek: transition orReturn: priority
    self error: 'deprecated'.
    self add: '('.
    self codeAssertPeek: transition.
    self addOnLine: ') ifFalse: [ '.
    self codeReturnResult: priority.
    self addOnLine: ']'.
    self codeDot.
!

codeAssertPeek: transition whileTrue: block
    self add: '['.
    self codeAssertPeek: transition.
    self addOnLine: '] whileTrue: ['.
    self indent.
    self code: block.
    self dedent.
    self add: '].'.
    self nl.
!

codeEndBlock
    self dedent.	
    self add: ']'.
!

codeEndBlockWhileTrue
    self dedent.	
    self code: '] whileTrue.'.
!

codeIfFalse
    self codeOnLine: ' ifFalse: ['.
!

codeNextChar
    self code: 'self step.'
!

codeNlAssertPeek: characterSet
    self add: ''.
    self codeAssertPeek: characterSet.
!

codeNlReturnResult
    self add: '^ self return.'
!

codeNlReturnResult: priority
    priority isNil ifTrue: [ 
        ^ self codeNlReturnResult
    ].
    self add: '^ self returnPriority: ', priority asString, '.'
!

codeRecordDistinctFailure: retval offset: value
    self add: 'self recordDistinctFailure: ', retval storeString, ' offset: ', value storeString, '.'
!

codeRecordDistinctMatch: retval offset: value
    self code: 'self recordDistinctMatch: ', retval storeString, ' offset: ', value storeString, '.'
!

codeRecordMatch: state priority: priority
    priority isNil ifTrue: [ 
        ^ self codeRecordMatch: state
    ].
    
    self add: 'self recordMatch: ', state storeString, ' priority: ', priority asString, '.'
!

codeReturn: code
    options profile ifTrue:[ 
        self codeProfileStop.
    ].   
    self code: '^ '.
    self codeOnLine: code            
!

codeReturnResult
    self addOnLine: '^ self return.'
!

codeReturnResult: priority
    self error: 'deprecated?'.
    priority isNil ifTrue: [ 
        ^ self codeReturnResult
    ].
    
    self addOnLine: '^ self returnPriority: ', priority asString, '.'
!

codeStartBlock
    self code: '['.
    self indent.
! !

!PPCFSACodeGen methodsFor:'coding - results'!

codeRecordDistinctFailure: retval
    self assert: retval isNil.
    
    self code: 'self recordDistinctFailure.'
!

codeRecordDistinctMatch: retval
    self code: 'self recordDistinctMatch: ', retval storeString, '.'
!

codeRecordFailure: index
    self assert: index isInteger.
    self code: 'self recordFailure: ', index asString, '.'
!

codeRecordMatch: retval
    self add: 'self recordMatch: ', retval storeString, '.'
!

codeRecordMatch: retval offset: offset
    self code: 'self recordMatch: ', retval storeString, ' offset: ', offset storeString, '.'
!

codeReturn
    self codeOnLine: '^ self'
!

codeReturnDistinct
    self codeOnLine: '^ self returnDistinct.'
! !

!PPCFSACodeGen methodsFor:'intitialization'!

initialize
    super initialize.
! !

