"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCStarNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCStarNode methodsFor:'accessing'!

acceptsEpsilon
    ^ true
!

acceptsEpsilonOpenSet: set
    ^ true
!

defaultName
    ^ #star
! !

!PPCStarNode methodsFor:'analysis'!

isNullable
    ^ true
!

recognizedSentencesPrim
    ^ 	#()
! !

!PPCStarNode methodsFor:'first follow next'!

followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet suchThat: aBlock
    | first |
    super followSets: aFollowDictionary firstSets:  aFirstDictionary into: aSet suchThat: aBlock.
    
    first := aFirstDictionary at: self.

    self children do: [ :el | 
        (aFollowDictionary at: el) addAll: (first reject: [:each | each isNullable])
    ]
! !

!PPCStarNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitStarNode: self
! !

