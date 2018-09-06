"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#Automaton
	instanceVariableNames:'transitions terminalPatterns initialTransitions canBeEmpty'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Patterns'
!


!Automaton class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 14-05-2005 / 18:58:36 / janfrog"
! !

!Automaton methodsFor:'initialization'!

initialize
    transitions := self transitionCollectionClass new.
    initialTransitions := self transitionCollectionClass new.
    terminalPatterns := Set new.

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
!

initializeFor:aPattern

    | node |
    node := aPattern node.
    canBeEmpty := node canBeEmpty.

    node contentModelInitialPatterns do:[:pattern|
        initialTransitions at:pattern name put:pattern
    ].

    terminalPatterns :=
        node contentModelFinalPatterns asSet.

    node generateTransitionsIn:self.
    node children do:[:child|
        self
            makeTransitionsFrom:child patternsThatCanBeLast
            to:child patternsThatCanBeNext
        ]

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
! !

!Automaton methodsFor:'printing'!

printOn:aStream

    self
        printTransitions:initialTransitions
        stateName:'#initialState'
        final:(initialTransitions isEmpty)
        on:aStream.
    

    transitions keysAndValuesDo:[:key :value|
        aStream cr.
        self
            printTransitions:value
            stateName:key nameForPrint
            final:(terminalPatterns includes:key)
            on:aStream.

    ]

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
!

printTransitions:aDictionary stateName:aString final:aBoolean on:aStream

    aStream nextPut:$[ ; nextPutAll:aString ; nextPut:$].
    aBoolean ifTrue:[aStream nextPutAll:' (final)'].
    aStream cr.
    aDictionary values do:[:pattern|
        aStream nextPutAll:' -> [',pattern nameForPrint,']'; cr
    ].

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
! !

!Automaton methodsFor:'private'!

addTarget:target toTransitions:dict 
    ^ dict at:target name put:target

    "Created: / 14-05-2005 / 19:01:43 / janfrog"
    "Modified: / 14-05-2005 / 20:11:07 / janfrog"
!

transitionCollectionClass
    ^ Dictionary

    "Created: / 14-05-2005 / 19:00:05 / janfrog"
    "Modified: / 14-05-2005 / 20:11:07 / janfrog"
! !

!Automaton methodsFor:'queries'!

isTerminalPattern:aPatternOrNil

    "nil is special value for initial state"

    ^aPatternOrNil ifNil:[
        canBeEmpty or:[initialTransitions isEmpty].
    ] ifNotNil:[
        terminalPatterns includes:aPatternOrNil
    ]

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
! !

!Automaton methodsFor:'states'!

makeTransitionsFrom:sourcePatterns to:targetPatterns 
    sourcePatterns asCollection do:[:source | 
        |dict|
        "/source isPatternNode ifTrue:[self halt].
        dict := transitions at:source ifAbsentPut:[ self transitionCollectionClass new ].
        targetPatterns asCollection do:[:target | 
            self addTarget:target toTransitions:dict
        ]
    ]

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
!

nextStateFrom:aPatternOrNil forTerminal:aString

    "if aPatternOrNil is nil, initialTransitions is used"
    "returns next pattern or nil if none found"

    aPatternOrNil ifNil:[
        ^initialTransitions
            at:aString ifAbsent:[nil]
    ].

    ^(transitions at:aPatternOrNil ifAbsent:[^nil])
        at:aString
        ifAbsent:[nil]

    "Created: / 14-05-2005 / 20:11:02 / janfrog"
! !

!Automaton methodsFor:'utilities'!

expectedPatternsFromState:aPatternOrNil

    ^aPatternOrNil ifNil:[
        initialTransitions values
    ] ifNotNil:[
        (transitions at:aPatternOrNil) values
    ]

    "Created: / 14-06-2005 / 12:13:40 / masca"
!

expectedTokensFromState:aPatternOrNil

    ^aPatternOrNil ifNil:[
        initialTransitions keys
    ] ifNotNil:[
        (transitions at:aPatternOrNil) keys
    ]

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
!

expectedTokensStringFromState:aPatternOrNil

    | s |   
    s := (String new:20) writeStream.
    (self expectedTokensFromState:aPatternOrNil)
        do:[:token|s nextPutAll:token]
        separatedBy:[s nextPutAll:', '].
    (self isTerminalPattern:aPatternOrNil) ifTrue:[
        s nextPutAll:' or nothing'
    ].
    ^s contents

    "Created: / 14-05-2005 / 18:56:31 / janfrog"
! !

!Automaton class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Automaton.st,v 1.1.1.1 2005-11-01 22:07:11 vranyj1 Exp $'
! !
