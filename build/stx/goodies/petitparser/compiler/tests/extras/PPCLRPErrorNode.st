"{ Package: 'stx:goodies/petitparser/compiler/tests/extras' }"

"{ NameSpace: Smalltalk }"

PPCLRPContainedElement subclass:#PPCLRPErrorNode
	instanceVariableNames:'block interpretedBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Extras-Tests-LRP'
!


!PPCLRPErrorNode methodsFor:'error handing'!

onErrorNode: aBlock parser: aLRPParser

    aLRPParser failWithValue: (aBlock value: self)
! !

!PPCLRPErrorNode methodsFor:'testing'!

isError
    ^true
! !

!PPCLRPErrorNode methodsFor:'visiting'!

acceptVisitor: aLRPNodeVisitor
    aLRPNodeVisitor visitErrorNode: self.
! !

!PPCLRPErrorNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

