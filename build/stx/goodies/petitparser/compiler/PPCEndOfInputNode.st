"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCEndOfInputNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCEndOfInputNode methodsFor:'accessing'!

defaultName
    ^ #endOfInput
! !

!PPCEndOfInputNode methodsFor:'analysis'!

acceptsEpsilon
    ^ false
!

acceptsEpsilonOpenSet: set
    ^ false
!

firstCharSet
    ^ PPCharSetPredicate on: [:e | true ] 
! !

!PPCEndOfInputNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitEndOfInputNode: self
! !

