"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCChoiceNode subclass:#PPCDeterministicChoiceNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCDeterministicChoiceNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitDeterministicChoiceNode: self
! !

!PPCDeterministicChoiceNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

