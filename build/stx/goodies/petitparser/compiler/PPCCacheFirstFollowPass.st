"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCPass subclass:#PPCCacheFirstFollowPass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Core'
!

!PPCCacheFirstFollowPass methodsFor:'running'!

run: ir
    "Actually run the pass on given IR (tree of PPCNode) and return
     (possibly transformed or completely new) another IR."

    | firstSets firstSetsWithTokens followSets followSetsWithTokens |

    "Cache first sets"
    firstSets := ir firstSets.
    ir allNodesDo: [ :node | node firstSet: (firstSets at: node) ].
    firstSetsWithTokens := ir firstSetsSuchThat: [:e | e isTerminal or: [ e isTokenNode ] ].
    ir allNodesDo: [ :node | node firstSetWithTokens: (firstSetsWithTokens at: node) ].

    "Cache follow sets"
    followSets := ir followSets.
    ir allNodesDo: [ :node | node followSet: (followSets at: node) ].
    followSetsWithTokens := ir followSetsSuchThat: [:e | e isTerminal or: [ e isTokenNode ] ].
    ir allNodesDo: [ :node | node followSetWithTokens: (followSetsWithTokens at: node) ].
    ^ ir

    "Created: / 29-08-2015 / 07:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

