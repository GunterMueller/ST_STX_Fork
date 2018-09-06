"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCNode subclass:#PPCEndOfFileNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

PPCEndOfFileNode class instanceVariableNames:'Instance'

"
 No other class instance variables are inherited by this class.
"
!

!PPCEndOfFileNode class methodsFor:'as yet unclassified'!

instance
    Instance isNil ifTrue: [
        Instance := self new.
    ].

    ^ Instance
! !

!PPCEndOfFileNode methodsFor:'accessing'!

defaultName
    ^ #eof
! !

!PPCEndOfFileNode methodsFor:'analysis'!

acceptsEpsilon
    ^ false
!

acceptsEpsilonOpenSet: set
    ^ false
!

firstCharSet
    ^ PPCharSetPredicate on: [:e | true ] 
! !

!PPCEndOfFileNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitEndOfFileNode: self.
! !

