"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCDelegateNode
	instanceVariableNames:'child'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCDelegateNode methodsFor:'accessing'!

child
    ^ child
!

child: whatever
    self assert: (whatever == self) not.
    child := whatever 
!

children
    ^ { child }
! !

!PPCDelegateNode methodsFor:'analysis'!

acceptsEpsilon
    ^ child acceptsEpsilonOpenSet: (IdentitySet with: self).
!

acceptsEpsilonOpenSet: set
    (set includes: child) ifFalse: [ 
        set add: child.
        ^ child acceptsEpsilonOpenSet: set 
    ].
    ^ false
!

recognizedSentencesPrim
    ^ self child recognizedSentencesPrim 
! !

!PPCDelegateNode methodsFor:'transformation'!

replace: node with: anotherNode
    self assert: (anotherNode == self) not.
    child == node ifTrue: [ child := anotherNode ]
! !

!PPCDelegateNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

