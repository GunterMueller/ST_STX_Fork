"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCDelegateNode subclass:#PPCAndNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!

!PPCAndNode methodsFor:'accessing'!

defaultName
    ^ #and
! !

!PPCAndNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitAndNode: self
! !

