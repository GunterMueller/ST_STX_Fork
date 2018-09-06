"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCNotNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCNotNode methodsFor:'accessing'!

defaultName
    ^ #not
! !

!PPCNotNode methodsFor:'analysis'!

firstCharSet
    ^ PPCharSetPredicate on: [:e | true ] 
!

isFirstSetTerminal
    ^ true
! !

!PPCNotNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitNotNode: self
! !

