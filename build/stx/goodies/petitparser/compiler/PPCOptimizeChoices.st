"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCRewritingVisitor subclass:#PPCOptimizeChoices
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Visitors'
!

!PPCOptimizeChoices methodsFor:'as yet unclassified'!

hasCommonPrefix: nodes
    | firstSets firstSetValues |
    firstSets := IdentityDictionary new.
    
    nodes do: [ :node |
        firstSets at: node put: node firstSetWithProductions.
    ].

    firstSetValues := firstSets values.

    firstSetValues do: [ :p1 |
        firstSetValues do:[ :p2 | 
            (p1 = p2) ifFalse: [ ^ false ] 
        ].
    ].
    ^ true

    "Modified: / 10-05-2015 / 07:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitChoiceNode: node
    | firstSets commonPrefix |
    firstSets := IdentityDictionary new.
    
    node children do: [ :child |
        firstSets at: child put: child firstProductions.
    ].

    commonPrefix := true.
    firstSets values allPairsDo: [ :p1 :p2 | (p1 = p2) ifFalse: [ commonPrefix := false ] ].
! !

