"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCActionNode subclass:#PPCMappedActionNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Nodes'
!


!PPCMappedActionNode methodsFor:'visiting'!

accept: visitor
    ^ visitor visitMappedActionNode: self

    "Created: / 02-06-2015 / 17:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PPCMappedActionNode class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

