"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCListNode subclass:#PPCChoiceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCChoiceNode methodsFor:'accessing'!

defaultName
    ^ #ch
! !

!PPCChoiceNode methodsFor:'analysis'!

acceptsEpsilon
    ^ self acceptsEpsilonOpenSet: IdentitySet new.
!

acceptsEpsilonOpenSet: set
    set add: self.
    ^ self children anySatisfy: [:e | e acceptsEpsilonOpenSet: set ].
!

check
    ^ self children asIdentitySet size = children size ifFalse: [ 
        Transcript cr; show: 'WARNING: Identical children in choice!!'; cr.
        nil.
    ] ifTrue: [ nil ]
!

recognizedSentencesPrim
    | retval |
    (self children anySatisfy: [ :child | child hasFiniteLanguage not ]) ifTrue: [ ^ #() ].
    
    retval := Set new.
    self children do: [ : child |
        retval addAll: child recognizedSentences.
    ].
    ^ retval asArray
! !

!PPCChoiceNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitChoiceNode: self
! !

!PPCChoiceNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

