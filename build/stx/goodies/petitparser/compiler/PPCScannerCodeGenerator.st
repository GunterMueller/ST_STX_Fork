"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPass subclass:#PPCScannerCodeGenerator
	instanceVariableNames:'codeGen fsa incommingTransitions resultStrategy fsaCache'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Scanner'
!

!PPCScannerCodeGenerator class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!PPCScannerCodeGenerator methodsFor:'accessing'!

codeGen
    ^ codeGen 
!

compiler
    ^ self codeGen 
! !

!PPCScannerCodeGenerator methodsFor:'analysis'!

analyzeDistinctRetvals
    (fsa hasNoRetvals) ifTrue: [
        ^ resultStrategy := PPCNoResultStrategy new
            codeGen: codeGen;
            yourself
    ].


    (fsa hasDistinctRetvals) ifTrue: [
        ^ resultStrategy := PPCDistinctResultStrategy new
            codeGen: codeGen;
            yourself
    ].

    resultStrategy := PPCUniversalResultStrategy new
        codeGen: codeGen;
        tokens: fsa retvals asArray;
        yourself
!

analyzeTransitions
    | transitions |
    transitions := fsa allTransitions.
    incommingTransitions := IdentityDictionary new.
    (self incommingTransitionsFor: fsa startState) add: #transitionStub.
    
    transitions do: [ :t |
        (self incommingTransitionsFor: t destination) add: t.
    ].
!

clazz: aPPCClass
    codeGen clazz: aPPCClass
!

containsBacklink: state
    state transitions do: [ :t |
        (self isBacklink:  t) ifTrue: [ ^ true ]
    ].

    ^ false
!

hasMultipleIncommings: state
    ^ (incommingTransitions at: state ifAbsent: [ self error: 'should not happen']) size > 1
!

incommingTransitionsFor: state
    ^ incommingTransitions  at: state ifAbsentPut: [ IdentitySet new ]
!

isSingleTerminatingRetval: state
    (state retvals size == 1 and: [ state isFinal ]) ifFalse: [ ^ false ].
    
    state transitions isEmpty ifTrue: [ ^ true ].
    ((state transitions size == 1) and: [state destination == state]) ifTrue: [ ^ self startsSimpleLoop: state ].
    
    ^ false
!

isSingleTransitionFsa
    fsa allTransitions size == 1 ifFalse: [ ^ false ].
    "do not allow loop!!"
    fsa startState destination == fsa startState ifTrue: [ ^ false ].
    "so far only single char allowed"
    fsa startState transition isCharacterTransition ifFalse: [ ^ false ].
    fsa startState transition isSingleCharacter ifFalse: [ ^ false ].
    ^ true
!

startsSimpleLoop: state
    |   |

    "
        This accepts more or less something like $a star
        for now.. might extend later
    "
    ((self incommingTransitionsFor: state) size == 2) ifFalse: [ ^ false ].
    ^ (state transitions select: [ :t | t destination == state ]) size == 1
    
! !

!PPCScannerCodeGenerator methodsFor:'caching'!

cache: anFsa method: method
    ^ fsaCache at: anFsa put: method
!

cachedValueForIsomorphicFsa: anFsa
    | key |
    key := fsaCache keys detect: [ :e | e isIsomorphicTo: anFsa ].
    ^ fsaCache at: key
!

isomorphicIsCached: anFsa
    ^ fsaCache keys anySatisfy: [ :e | (e isIsomorphicTo: anFsa) and: [ e name = anFsa name ] ]
! !

!PPCScannerCodeGenerator methodsFor:'code generation'!

generate
    self assert: fsa isDeterministic.
    self assert: fsa isWithoutEpsilons.
    self assert: fsa checkConsistency.

    (self isomorphicIsCached: fsa) ifTrue: [ 
        "JK: please not, right now, checks for isomorphism and name
            this might be improved in future and name can be 'reused'
        "
        ^ self cachedValueForIsomorphicFsa: fsa 
    ].

    self analyzeTransitions.
    self analyzeDistinctRetvals.
    
    codeGen startMethod: (codeGen idFor: fsa).
"	codeGen codeComment: (Character codePoint: 13) asString, fsa asString."
    resultStrategy reset.

    self generateFor: fsa startState.

    ^ self cache: fsa method: codeGen stopMethod.


!

generate: aPEGFsa
    fsa := aPEGFsa.

    self assert: fsa isDeterministic.
    self assert: fsa isWithoutPriorities.
    
    fsa minimize.
    fsa checkSanity.
    
    ^ self generate
!

generateAndCompile
    self generate.
    ^ self compile
!

generateAndCompile: aPEGFsa
    fsa := aPEGFsa.

    fsa minimize.
    fsa checkSanity.
    
    ^ self generateAndCompile
!

generateFinalFor: state
    ^ self generateFinalFor: state offset: 0
!

generateFinalFor: state offset: offset
    "Handle one retval specially"
    (self isSingleTerminatingRetval: state) ifTrue: [  
        state isFsaFailure ifTrue: [ 
            resultStrategy returnFailure: state retval offset: offset.
        ] ifFalse: [ 
            resultStrategy returnMatch: state retval offset: offset.
        ].
        ^ self
    ].

    state retvalsAndInfosDo: [:retval :info |
        info isFinal ifTrue: [ 
            info isFsaFailure ifTrue: [ 
                resultStrategy recordFailure: retval offset: offset
            ] ifFalse: [ 
                resultStrategy recordMatch: retval offset: offset
            ]
        ].
    ]
!

generateFor: state
    codeGen cachedMethod: (codeGen idFor: state) ifPresent: [ :method | 
        "if state is already cached, it has multiple incomming links.
     	 In such a case, it is compiled as a method, thus return immediatelly"
        ^ codeGen codeAbsoluteReturn:  method call
    ].

    self flag: 'TODO JK: Hack alert, fix this:'.
    (state isKindOf: PEGFsaParserState) ifTrue: [ 
        | id |
        self assert: state transitions isEmpty.
        id := codeGen idFor: state parser defaultName: 'parser'.
        codeGen addConstant: state parser as: id.
        codeGen code: id, ' parseOn: context'.
        ^ self
    ].

    (self isSingleTransitionFsa) ifTrue: [ 
        ^ self generateForSingleTransitionFsa: state.
    ].

    (self startsSimpleLoop: state) ifTrue: [ 
        ^ self generateSimpleLoopFor: state
    ].
    
    ^ self generateStandardFor: state
!

generateForSingleTransitionFsa: startState
    | transition |
    self assert: fsa startState == startState.
    
    transition := startState transition.
    
    transition isSingleCharacter ifTrue: [ 
        codeGen codeIf: 'context peek == ', transition character storeString then: [ 
            codeGen code: 'self step'; codeDot.
            self generateFinalFor: transition destination.
        ]. 
        codeGen codeReturn: 'false'.
    ] ifFalse: [ 
        self error: 'should be implemented'
    ]
!

generateForTransition: t from: state		
"   
    (self isBacklink: t) ifTrue: [ 
        codeGen codeAssertPeek: (t characterSet) ifTrue: [ 
            codeGen add: 'true'
        ]
    ] ifFalse: [ 
        codeGen codeAssertPeek: (t characterSet) ifTrue: [
            self generateFor: t destination.
        ].
    ].
"
    codeGen codeAssertPeek: t ifTrue: [
        self generateFor: t destination.
    ].
    codeGen codeIfFalse.
!

generateNextFor: state
    state transitions isEmpty ifTrue: [  ^ self ].
    codeGen codeNextChar.
!

generateReturnFor: state
"	codeGen codeNl."
    (self isSingleTerminatingRetval: state) ifFalse: [ 
        resultStrategy returnResult: state.
    ] ifTrue: [ 
 		"return already generated within the match"	
    ]
!

generateSimpleLoopFor: state
    | selfTransition |
    selfTransition := state transitions detect: [ :t | t destination == state ].
    
    codeGen codeStartBlock.
    codeGen codeNextChar.
    codeGen codeNl.
    codeGen codeAssertPeek: selfTransition.
    codeGen codeEndBlockWhileTrue.

    "Last transition did not passed the loop, therefore, we have to record succes with offset -1"
    self generateFinalFor: state offset: 1.
    self generateTransitions: (state transitions reject: [ :t | t == selfTransition  ]) 
            for: state 
            offset: 1.
    
!

generateStandardFor: state
    self generateStartMethod: state.
    self generateFinalFor: state.
    self generateNextFor: state.
    self generateTransitionsFor: state.

    self generateStopMethod: state.
!

generateStartMethod: state
    | id |
    id := codeGen idFor: state.

    codeGen codeComment: 'START - Generated from state: ', state asString.

    (self hasMultipleIncommings: state) ifTrue: [ 
        codeGen startMethod: id.
    ] ifFalse: [ 
        codeGen  startInline: id.
    ]
!

generateStopMethod: state
    |  |
    (self hasMultipleIncommings: state) ifTrue: [ 
        codeGen codeAbsoluteReturn: codeGen stopMethod call.
    ] ifFalse: [ 
        codeGen code: codeGen stopInline call.
    ].
    codeGen codeComment: 'STOP - Generated from state: ', state asString.
!

generateTransitions: transitions for: state offset: offset
    (transitions size = 0) ifTrue: [  
        (offset > 0 and: [ state isFinal not ]) ifTrue:  [ 
            codeGen codeIf: 'currentChar isNil' then: nil else: [ 
                codeGen codeOnLine: 'context skip: -', offset asString 
            ].
        ].
        ^ self	
    ].

"	codeGen codeNl.
"	transitions do: [ :t |
        self generateForTransition: t from: state
    ].

    codeGen indent.
    self generateReturnFor: state.
    codeGen dedent.
    codeGen codeNl.
    transitions size timesRepeat: [ codeGen codeOnLine: ']' ].
    codeGen codeDot.
    

"	self closedJoinPoints isEmpty ifFalse: [ 
        | jp |
        self assert: self closedJoinPoints size == 1.

        jp := self closedJoinPoints anyOne.
        self removeJoinPoint: jp.
        self generateFor: jp.
    ]
"
!

generateTransitionsFor: state
    ^ self generateTransitions: state transitions for: state offset: 0
!

setMaxNumericId
    codeGen addConstant: codeGen idGen numericIds size as: #MaxSymbolNumber 
!

setTokens
    | tokens |
    tokens := Array new: codeGen idGen numericIdCache size.
    
    codeGen idGen numericIdCache keysAndValuesDo: [ :key :value |
        tokens at: value put: key
    ].

    codeGen addConstant: tokens as: #Tokens 
! !

!PPCScannerCodeGenerator methodsFor:'compiling'!

compile
    ^ self compileScannerClass new
!

compileScannerClass
    | builder |
    self setMaxNumericId.
    self setTokens.
    
    builder := PPCClassBuilder new.
    
    builder compiledClassName: context options scannerName.
    builder compiledSuperclass: context options scannerSuperclass.
    builder methodDictionary: codeGen clazz methodDictionary.
    builder constants: codeGen clazz constants.

    ^ builder compileClass.

    "Modified: / 03-09-2015 / 22:00:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCScannerCodeGenerator methodsFor:'initialization'!

initialize
    super initialize.
    
    codeGen := PPCFSACodeGen new.
    context := PPCCompilationContext new.
    fsaCache := IdentityDictionary new.

    "Modified: / 03-09-2015 / 22:27:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCScannerCodeGenerator methodsFor:'running'!

run: ir
    "Actually run the pass on given IR (tree of PPCNode) and return
     (possibly transformed or completely new) another IR."

    | fsas |

    fsas := IdentitySet new.
    fsaCache := IdentityDictionary new.               
    fsas addAll:(ir allNodes 
                select:[:node | node hasFsa ]
                thenCollect:[:node | node fsa ]).
    fsas addAll:(ir allNodes 
                select:[:node | node hasNextFsa ]
                thenCollect:[:node | node nextFsa ]).
    fsas := fsas select:[:each | each hasDistinctRetvals].
    codeGen clazz:context scannerClass.
    codeGen options: context options.

    fsas do:[:each | 
        self generate:each
    ].
    ^ ir

    "Created: / 03-09-2015 / 21:55:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-09-2015 / 06:21:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

