"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#ValidatorContext
	instanceVariableNames:'remainingAttributes automaton currentPattern owningPattern
		validator'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Validation'
!


!ValidatorContext class methodsFor:'instance creation'!

for:aContentModelAutomaton

    ^self new pattern:aContentModelAutomaton

    "Created: / 01-05-2005 / 12:50:28 / janfrog"
    "Modified: / 01-05-2005 / 16:11:36 / janfrog"
! !

!ValidatorContext methodsFor:'accessing'!

attributes
    ^ remainingAttributes

    "Created: / 01-05-2005 / 12:46:58 / janfrog"
!

attributes:something
    remainingAttributes := something.

    "Created: / 01-05-2005 / 12:46:58 / janfrog"
!

automaton
    ^ automaton

    "Created: / 14-05-2005 / 11:30:22 / janfrog"
!

currentPattern
    ^ currentPattern

    "Created: / 02-05-2005 / 15:20:30 / janfrog"
!

pattern
    ^ owningPattern

    "Created: / 01-05-2005 / 16:11:44 / janfrog"
    "Modified: / 01-05-2005 / 18:29:05 / janfrog"
!

pattern:aPattern
    owningPattern := aPattern.
    automaton := aPattern contentModelAutomaton

    "Created: / 01-05-2005 / 16:11:44 / janfrog"
    "Modified: / 01-05-2005 / 18:29:05 / janfrog"
!

validator
    ^ validator

    "Created: / 02-05-2005 / 12:19:20 / janfrog"
!

validator:aValidator
    validator := aValidator.

    "Created: / 02-05-2005 / 12:19:20 / janfrog"
! !

!ValidatorContext methodsFor:'initialization'!

initialize

    "Must be called AFTER automaton and remainingAttributes are 
     set up!!!!!!"

    "Created: / 01-05-2005 / 12:51:22 / janfrog"
! !

!ValidatorContext methodsFor:'printing'!

printOn:aStream

    aStream nextPutAll:
        'Validator context for:' ,  owningPattern nameForPrint

    "Created: / 19-05-2005 / 10:29:49 / masca"
! !

!ValidatorContext methodsFor:'queries'!

expectedPatterns

    ^automaton expectedPatternsFromState:currentPattern

    "Created: / 14-06-2005 / 12:10:54 / masca"
!

finished

    ^(automaton isTerminalPattern:currentPattern)
        and:[remainingAttributes isNilOrEmptyCollection]

    "Created: / 01-05-2005 / 16:18:38 / janfrog"
    "Modified: / 19-05-2005 / 10:02:59 / masca"
! !

!ValidatorContext methodsFor:'running'!

nextPutElement:aString
    "expandedName"

    "Answers pattern for given expanded name or pattern
     for any attribute if applicable. When no new pattern
     can be found in transition table, an error is reported"

    | newPattern |

    [self tryAnyAttribute] whileTrue.
    
    newPattern := (automaton 
                    nextStateFrom:currentPattern 
                    forTerminal:aString).
    newPattern 
        ifNil:[^validator 
            validationError:('Unexpected element <',aString, 
                '/>. Expecting: ', (automaton expectedTokensStringFromState:currentPattern)) ].
    ^currentPattern := newPattern.

    "Created: / 01-05-2005 / 13:02:09 / janfrog"
    "Modified: / 14-05-2005 / 11:17:36 / janfrog"
!

nextPutText:aString

    | pcdataPattern |

    [self tryAnyAttribute] whileTrue.

    pcdataPattern := automaton 
                        nextStateFrom:currentPattern 
                        forTerminal:'#pcdata'.
    pcdataPattern ifNil:[
        validator 
            validationError:('Unexpected #pcdata.  Expecting: ', 
                (automaton expectedTokensStringFromState:currentPattern))
    ] ifNotNil:[
        pcdataPattern validate:aString for:validator.
        currentPattern := pcdataPattern.
    ].

    "Created: / 01-05-2005 / 16:05:28 / janfrog"
    "Modified: / 14-05-2005 / 11:18:35 / janfrog"
    "Modified: / 19-05-2005 / 09:52:20 / masca"
!

tryAnyAttribute

    "Answers true, if any attribute was eaten, or false otherwise"


    |pattern|
    remainingAttributes ifNil:[^false].
    remainingAttributes do:[:attr | 
        (pattern := automaton nextStateFrom:currentPattern forTerminal:attr expandedName) 
            ifNotNil:[
                currentPattern := pattern.
                validator processAttribute:attr usingPattern:pattern.
                currentPattern := pattern.
                remainingAttributes remove:attr.
                ^true
            ]
    ].
    ^false

    "Created: / 02-05-2005 / 12:28:53 / janfrog"
    "Modified: / 19-05-2005 / 09:52:50 / masca"
!

tryToFinish

    | expectedPatterns |

    [self tryAnyAttribute] whileTrue.

    expectedPatterns := self expectedPatterns.

    expectedPatterns size = 1 ifTrue:[
        "Maybe a pcdata pattern that accepts empty string?"
        expectedPatterns first acceptsEmptyStringAsContent ifTrue:[
            self nextPutText:''.
        ]
    ]

    "Created: / 14-06-2005 / 12:19:19 / masca"
! !

!ValidatorContext class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ValidatorContext.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
