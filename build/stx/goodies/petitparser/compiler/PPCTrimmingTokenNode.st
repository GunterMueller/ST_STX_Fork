"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCListNode subclass:#PPCTrimmingTokenNode
	instanceVariableNames:'tokenClass'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCTrimmingTokenNode methodsFor:'accessing'!

child
    
    ^ children at: 2
!

child: anObject
    
    children at: 2 put: anObject
!

tokenClass
    
    ^ tokenClass
!

tokenClass: anObject
    
    tokenClass := anObject
!

whitespace
    
    ^ children at: 1
!

whitespace: anObject
    (anObject name isNil and: [ self child name isNotNil ]) ifTrue: [ 
        anObject name: self child name, '_ws'.
    ].
    children at: 1 put: anObject
! !

!PPCTrimmingTokenNode methodsFor:'analyzing'!

acceptsEpsilon
    ^ self child acceptsEpsilonOpenSet: (IdentitySet with: self).
!

acceptsEpsilonOpenSet: set
    (set includes: self child) ifFalse: [ 
        set add: self child.
        ^ self child acceptsEpsilonOpenSet: set 
    ].
    ^ false
!

firstSetSuchThat: block into: aCollection openSet: aSet
    (aSet includes: self) ifTrue: [ ^ aCollection ].
    aSet add: self.
    
    (block value: self) ifTrue: [ aCollection add: self. ^ aCollection ].
    
    ^ self child firstSetSuchThat: block into: aCollection openSet: aSet.
!

firstSets: aFirstDictionary into: aSet suchThat: aBlock
    "PRIVATE: Try to add additional elements to the first-set aSet of the receiver, use the incomplete aFirstDictionary."

    (aBlock value: self) ifFalse: [ 
        aSet addAll: (aFirstDictionary at: self child)
    ]
!

recognizedSentencesPrim
    ^ self child recognizedSentencesPrim 
! !

!PPCTrimmingTokenNode methodsFor:'comparing'!

= anotherNode
    super = anotherNode ifFalse: [ ^ false ].
    ^ tokenClass = anotherNode tokenClass.
!

hash
    ^ super hash bitXor: tokenClass hash
! !

!PPCTrimmingTokenNode methodsFor:'ids'!

defaultName
    ^ #token
! !

!PPCTrimmingTokenNode methodsFor:'initialization'!

initialize
    super initialize.
    children := Array new: 2
! !

!PPCTrimmingTokenNode methodsFor:'testing'!

isTokenNode
    ^ true
!

isTrimmingTokenNode
    ^ true
! !

!PPCTrimmingTokenNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitTrimmingTokenNode: self
! !

!PPCTrimmingTokenNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

