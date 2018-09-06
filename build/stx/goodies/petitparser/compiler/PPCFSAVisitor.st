"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPassVisitor subclass:#PPCFSAVisitor
	instanceVariableNames:'fsaCache idGen'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCFSAVisitor methodsFor:'as yet unclassified'!

unorderedChoiceFromFollowSet: followSet
    | followFsas  |
    
    ^ fsaCache at: followSet ifAbsentPut: [ 
        followFsas := followSet collect: [ :followNode | 
            followNode asFsa 
                name: (context idGenerator  idFor: followNode);
                retval: (context idGenerator  idFor: followNode); 
                yourself
        ].
        self unorderedChoiceFromFsas: followFsas.
    ]

    "Modified: / 03-09-2015 / 21:28:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unorderedChoiceFromFsas: fsas
    | result startState |
    result := PEGFsa new.
    startState := PEGFsaState new.
    
    result addState: startState.
    result startState: startState.

    fsas do: [ :fsa | 
        result adopt: fsa.
        result addTransitionFrom: startState to: fsa startState.
    ].

    result determinizeStandard.
    ^ result
!

visitToken: tokenNode
    | anFsa |

    anFsa := tokenNode asFsa determinize.
    anFsa name: (context idGenerator idFor: tokenNode).
    anFsa retval: (context idGenerator idFor: tokenNode).
    
    tokenNode fsa: anFsa.
    ^ tokenNode

    "Modified: / 03-09-2015 / 21:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitTokenConsumeNode: node
    | epsilon anFsa followSet |
    followSet := node followSetWithTokens.
    
    epsilon := followSet anySatisfy: [ :e | e acceptsEpsilon ].
    followSet := followSet reject: [ :e | e acceptsEpsilon ].
    epsilon ifTrue: [ followSet add: PPCEndOfFileNode instance ].
    
    anFsa := self unorderedChoiceFromFollowSet: followSet.
    anFsa name: 'nextToken_', (context idGenerator idFor: node).

    node nextFsa: anFsa.

    "Modified: / 03-09-2015 / 21:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitTokenNode: node
    ^ self visitToken: node
!

visitTokenizingParserNode: node
    "TODO JK: hack alert, change the handling of WS!!"
    self visitWhitespace: node whitespace.

    self visit: node tokens.
    self visit: node parser.
    ^ node
!

visitTrimmingTokenNode: node
    ^ self visitToken: node
!

visitWhitespace: node
    "JK HACK: treat ws as token -> create FSA for whitespace"
    | retval |
    retval := self visitToken: node.
    "we don't care about the finals of whitespace"
    node fsa removeFinals.
    ^ retval
! !

!PPCFSAVisitor methodsFor:'initialization'!

initialize
    super initialize.
    
    "for the given set of nodes, remember the unordered choice fsa
        see `unorderedChoiceFromFollowSet:`
    "
    fsaCache := Dictionary new.
! !

