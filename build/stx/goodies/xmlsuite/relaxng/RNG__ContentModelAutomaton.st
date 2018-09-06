"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#ContentModelAutomaton
	instanceVariableNames:'transitions terminalPatterns initialTransitions canBeEmpty'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Patterns'
!


!ContentModelAutomaton class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 30-04-2005 / 20:21:10 / janfrog"
! !

!ContentModelAutomaton methodsFor:'accessing'!

newContext

    ^ContentModelAutomaton for:self

    "Created: / 01-05-2005 / 12:49:54 / janfrog"
! !

!ContentModelAutomaton methodsFor:'initialization'!

initialize

    transitions := Dictionary new.
    initialTransitions := Dictionary new.
    terminalPatterns := Set new.

    "Created: / 30-04-2005 / 20:21:10 / janfrog"
    "Modified: / 30-04-2005 / 22:19:31 / janfrog"
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

    "Created: / 30-04-2005 / 20:50:40 / janfrog"
    "Modified: / 02-05-2005 / 12:07:21 / janfrog"
! !

!ContentModelAutomaton methodsFor:'printing'!

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

    "Created: / 30-04-2005 / 21:50:28 / janfrog"
    "Modified: / 01-05-2005 / 12:43:56 / janfrog"
!

printTransitions:aDictionary stateName:aString final:aBoolean on:aStream

    aStream nextPut:$[ ; nextPutAll:aString ; nextPut:$].
    aBoolean ifTrue:[aStream nextPutAll:' (final)'].
    aStream cr.
    aDictionary values do:[:pattern|
        aStream nextPutAll:' -> [',pattern nameForPrint,']'; cr
    ].

    "Created: / 30-04-2005 / 21:22:29 / janfrog"
    "Modified: / 01-05-2005 / 12:43:26 / janfrog"
! !

!ContentModelAutomaton methodsFor:'queries'!

isTerminalPattern:aPatternOrNil

    "nil is special value for initial state"

    ^aPatternOrNil ifNil:[
        canBeEmpty or:[initialTransitions isEmpty].
    ] ifNotNil:[
        terminalPatterns includes:aPatternOrNil
    ]

    "Created: / 01-05-2005 / 12:55:33 / janfrog"
    "Modified: / 02-05-2005 / 12:06:49 / janfrog"
! !

!ContentModelAutomaton methodsFor:'states'!

makeTransitionsFrom:sourcePatterns to:targetPatterns

    sourcePatterns asCollection do:[:source|
        | dict |
        "/source isPatternNode ifTrue:[self halt].
        dict := transitions at:source ifAbsentPut:[Dictionary new].
        targetPatterns asCollection do:[:target|
            dict at:target name put:target
        ]
    ]

    "Created: / 30-04-2005 / 20:23:36 / janfrog"
    "Modified: / 01-05-2005 / 12:24:59 / janfrog"
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

    "Created: / 30-04-2005 / 20:44:28 / janfrog"
    "Modified: / 01-05-2005 / 12:57:48 / janfrog"
! !

!ContentModelAutomaton class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ContentModelAutomaton.st,v 1.1.1.1 2005-11-01 22:07:13 vranyj1 Exp $'
! !
