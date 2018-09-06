"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCStarNode subclass:#PPCStarAnyNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCStarAnyNode methodsFor:'as yet unclassified'!

defaultName
    ^ #starAny
! !

!PPCStarAnyNode methodsFor:'first follow next'!

firstSets: aFirstDictionary into: aSet suchThat: aBlock
    "
        First and follow should be performed on the non-specialized tree, i.e. on a tree
        with star -> messageNode. Not on myself.
        
        The reason for that is, that:
        - I am terminal
        - I am nullable
        
        This means, I look like epsilon node for the first follow analysis. And epsilons 
        are ignored in sequences, thus sequence of StarMessagePredicate, Literal
        leads to { Literal } as firstSet and not expected { MessagePredicate, Literal }
    "
    ^ self error: 'Cannot perform first/follow analysis on myself, sorry for that :('
! !

!PPCStarAnyNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitStarAnyNode: self
! !

!PPCStarAnyNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

